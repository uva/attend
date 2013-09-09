## README

1. `git clone git@github.com:uva/attend.git`
2. `bundle install`
3. `rake db:setup`
4. update the `.env` file with the following variables:
   - SECRET_TOKEN (generate with `require 'securerandom'; SecureRandom.hex(64)`)
   - IMPORT_URL
   - IMPORT_USERNAME
   - IMPORT_PASSWORD
5. `rails s`
