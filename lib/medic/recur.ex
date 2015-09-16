defmodule Medic.Recur do
  defmacro __using__(_opts) do
    quote do
      use GenServer
      require Logger

      def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      def init(opts) do
        :timer.send_after(1, self, :tick)
        {:ok, opts}
      end

      def handle_info(:tick, opts) do
        GenServer.cast(self, :tick)

        :timer.send_after(opts[:interval], self, :tick)

        {:noreply, opts}
      end
      def handle_info(_, opts), do: {:noreply, opts}
    end
  end
end
