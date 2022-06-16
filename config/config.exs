import Config

config :trader,
  ecto_repos: [Trader.Repo],
  generators: [binary_id: true]

config :trader, Trader.Repo, database: "trader.db"

config :trader,
  binance_stream_base_url: "wss://stream.binance.com:9443/ws/",
  mercado_bitcoin_base_url: "https://www.mercadobitcoin.net/api/"

config :number,
  currency: [
    unit: "",
    precision: 2,
    delimiter: ".",
    separator: ",",
    format: "%u%n",
    negative_format: "(%u%n)"
  ]
