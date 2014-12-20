$redis = Redis.new(
  host: Rails.application.secrets.redis_host || "localhost",
  port: Rails.application.secrets.redis_port || 6379,
  db: Rails.application.secrets.redis_db || 30
)
