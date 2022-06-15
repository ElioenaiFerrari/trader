import Config

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
