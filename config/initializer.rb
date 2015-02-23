DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://rar-api.db')
