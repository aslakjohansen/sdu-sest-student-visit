defmodule Gateway do
  use GenServer
  
  # behaviour functions
  
  def start_link(topic, device, speed) do
    GenServer.start_link(
      __MODULE__,
      {topic, device, speed},
      name: via_tuple(device)
    )
  end
  
  def publish(device, payload) do
    GenServer.cast(via_tuple(device), {:publish, payload})
  end

  defp via_tuple(device) do
    GatewayRegistry.via_tuple({__MODULE__, device})
  end

  # callback functions
  
  @impl true
  def init({topic, device, speed}) do
      state = %{speed: speed, device: device, topic: topic}
      try do
        {:ok, uart_pid} = Circuits.UART.start_link()
        :ok = Circuits.UART.open(uart_pid, device, speed: speed, active: true)
        {:ok, pub_pid} = Publisher.start_link(topic: topic)
        {:ok, Map.merge(state, %{uart: uart_pid, pub: pub_pid})}
      rescue
        _ -> disconnect(state)
      end
  end
  
  @impl true
  def handle_info({:circuits_uart, _, {:error, :eio}}, state) do
    disconnect(state)
  end
  
  @impl true
  def handle_info({:circuits_uart, _, payload}, state) do
    case Jason.decode(payload) do
      {:ok, _} -> Publisher.publish(state[:pub], payload)
      {:error, _} -> nil
    end
    {:noreply, state}
  end
  
  # callback helpers
  
  defp disconnect(state) do
    IO.puts("Exiting gateway")
    Registry.unregister(GatewayRegistry, state[:device])
    {:stop, :error, state}
  end
end
