defmodule Scanner do
  use GenServer
  
  @sleeptime 1000*10
  @topic "dk/sdu/sest/test"
  
  def start_link(_) do
    GenServer.start(Scanner, {})
  end
  
  def init(_) do
    Process.send_after(self(), :scan, 0)
    {:ok, %{}}
  end
  
  def handle_info(:scan, state) do
    IO.puts("Scanning ...")
    
    uarts = Circuits.UART.enumerate()
    
    for {device, description} <- uarts do
      IO.puts("- #{device}")
      {match, speed} =
      case description do
        %{description:  "SmartEverything Fox3",
          manufacturer: "Arduino LLC"}
          -> {true, 9600}
        %{description:  "CP2102 USB to UART Bridge Controller",
          manufacturer: "Silicon Labs"}
          -> {true, 115200}
        %{description: "USB Serial",
          product_id: 29987,
          vendor_id: 6790}
          -> {true, 9600}
        _ -> {false, nil}
      end
      if match do
        case Gateway.start_link(@topic, device, speed) do
          {:ok, pid} ->
            Map.put(state, device, pid) #TODO: this pid cannot be trusted, and is not used
          {:error, _} -> nil
        end
      end
    end
    
    Process.send_after(self(), :scan, @sleeptime)
    {:noreply, state}
  end
end
