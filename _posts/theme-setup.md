Setting up a theme

vi Gemfile
add line below (for leap day theme)

gem 'jekyll-theme-leap-day'

vi _config.yml
add line below (for leap day theme)

theme: jekyll-theme-leap-day

then in repo

// setup proxy
export http_proxy="https://xxx.x.xx.xx:8080"
export https_proxy="https://xxx.x.xx.xx:8080"

// install bundle for theme
bundle install

// start jekyll
jekyll serve



