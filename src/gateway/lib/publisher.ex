defmodule Publisher do
  @host "broker.hivemq.com"
  @port 1883
  
  use GenServer
  
  # behaviour functions
  
  def start_link(args) do
    GenServer.start(Publisher, args)
  end
  
  def publish(pid, payload) do
    GenServer.cast(pid, {:publish, payload})
  end
  
  # callback functions
  
  @impl true
  def init(args) do
      time = DateTime.utc_now() |> DateTime.to_unix(:nanosecond)
      client_id = "#{time}"
      {:ok, _pid} = Tortoise.Connection.start_link(
          client_id: client_id,
          server: {Tortoise.Transport.Tcp, host: @host, port: @port},
          handler: {Tortoise.Handler.Logger, []},
      )
      {:ok, %{client_id: client_id, topic: args[:topic]}}
  end
  
  @impl true
  def handle_cast({:publish, payload}, state) do
    client_id = Map.get(state, :client_id)
    topic     = Map.get(state, :topic)
    Tortoise.publish(client_id, topic, payload)
    {:noreply, state}
  end
end
