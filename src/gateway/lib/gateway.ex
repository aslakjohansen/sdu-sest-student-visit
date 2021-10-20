defmodule Gateway do
  use GenServer
  
  # behaviour functions
  
  def start_link(topic, name, description) do
    GenServer.start(Gateway, {topic, name, description})
  end
  
  def publish(pid, payload) do
    GenServer.cast(pid, {:publish, payload})
  end

  # callback functions
  
  @impl true
  def init({topic, name, description}) do
      {speed} =
      case description do
        %{description:  "SmartEverything Fox3",
          manufacturer: "Arduino LLC"}
          -> {9600}
        %{description:  "CP2102 USB to UART Bridge Controller",
          manufacturer: "Silicon Labs"}
          -> {115200}
      end
      {:ok, uart_pid} = Circuits.UART.start_link()
      :ok = Circuits.UART.open(uart_pid, name, speed: speed, active: true)
      {:ok, pub_pid} = Publisher.start_link(topic: topic)
      {:ok, %{speed: speed, uart: uart_pid, pub: pub_pid}}
  end
  
  @impl true
  def handle_info({:circuits_uart, _, payload}, state) do
#    IO.puts("payload '#{payload}'")
    Publisher.publish(state[:pub], payload)
    {:noreply, state}
  end
end
