get "/" do
  erb :index, views: settings.views + '/root'
end
