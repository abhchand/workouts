get "/", auth: :person do
  @active_challenges =
    Challenge
    .includes(:participants)
    .where("ended_at > ?", Time.now)
    .order(started_at: :desc)

  erb :"root/index"
end
