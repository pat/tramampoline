desc "Auto-compile the SCSS"
task :scss do
  `sass --watch app/views/styles:public/stylesheets`
end
