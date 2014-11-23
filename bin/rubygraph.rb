#!/usr/bin/env ruby
 
require 'main'
 
 Main {
   argument 'root'
   option 'autoopen'
   
   def run
     root = params['root'].value
     info { "Creating dependency graph for ruby code in #{root}" }
     
     exit_success!
   end
 }
 
