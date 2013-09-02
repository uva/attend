json.array!(@users) do |user|
  json.extract! user, :name, :uvanetid, :is_admin
  json.url user_url(user, format: :json)
end
