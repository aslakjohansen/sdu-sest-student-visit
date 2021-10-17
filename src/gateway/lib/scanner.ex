defmodule Scanner do
  use GenServer
  
  @sleeptime 1000*10
  
  def init(_) do
    Process.send_after(self(), :scan, 0)
    {:ok, %{}}
  end
  
  def handle_info(:scan, state) do
    IO.puts("Scanning ...")
    
    uarts = Circuits.UART.enumerate()
    for {k, v} <- uarts do
      IO.puts("- #{k}")
    end
    
    Process.send_after(self(), :scan, @sleeptime)
    {:noreply, state}
  end
end
