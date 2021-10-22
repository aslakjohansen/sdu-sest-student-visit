defmodule Scanner do
  use GenServer
  
  @sleeptime 1000*10
  
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
    
    previous = Map.keys(state) |> MapSet.new()
    current  = Map.keys(uarts) |> MapSet.new()
    
    appearances    = MapSet.difference(current, previous) |> MapSet.to_list()
    disappearances = MapSet.difference(previous, current) |> MapSet.to_list()
    
    # removed devices
    state = disappearances
          |>Enum.reduce(state, fn device, state -> Map.delete(state, device) end)
#    for device <- disappearances do
#      # supervisor
#      Map.delete(state, device)
#    end
    
    # new devices
    adder = fn device, state ->
      description = uarts[device]
      {match, speed} =
      case description do
        %{description:  "SmartEverything Fox3",
          manufacturer: "Arduino LLC"}
          -> {true, 9600}
        %{description:  "CP2102 USB to UART Bridge Controller",
          manufacturer: "Silicon Labs"}
          -> {true, 115200}
        _ -> {false, nil}
      end
      if match do
        topic = "dk/sdu/sest/test"
        case Gateway.start_link(topic, device, speed) do
          {:ok, pid} ->
            Map.put(state, device, pid) #TODO: this pid cannot be trusted, and is not used
          {_} -> nil
        end
      else
        state
      end
    end
    state = appearances |> Enum.reduce(state, adder)
#    for device <- appearances do
#      
##      # supervisor
##      state = Map.put(state, device, 42)
#    end
    
    
    for {k, _v} <- uarts do
      IO.puts("- #{k}")
#      state = Map.put_new_lazy(state, v, GenServer.start(Gateway, v))
    end
    
    Process.send_after(self(), :scan, @sleeptime)
    {:noreply, state}
  end
end
