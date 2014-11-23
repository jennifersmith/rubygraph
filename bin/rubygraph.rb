#!/usr/bin/env ruby
 
require 'main'
require 'parser/current'
require 'ast/node'

def is_require? ast
  ast.type == :send &&
  ast.children[0].nil?
  ast.children[1] == :require
end
def find_requires ast, &block
  return if ast.nil?
  if is_require? ast
    yield ast.children[2].children[0].gsub(/.rb$/, "")
  else 
    ast.children.each do |ast|
      find_requires ast, &block if ast.is_a?(AST::Node)
    end
  end
end

def make_safe_for_graphviz name
  name.gsub(/^lib\//, "").gsub(/\s|\//, "_").gsub(".rb", "")
end

def make_relative root,path
  path.gsub(root,"")
end


 Main {
   argument 'root'
   option 'autoopen'
   
   def run
     root = params['root'].value
     

     info { "Creating dependency graph for ruby code in #{root}" }
     
     puts "digraph {"
     Dir.glob(File.join(root, "**", "*.rb")).each do |f|
       relative = make_relative(root,f)
       from = make_safe_for_graphviz(relative)
       ast = Parser::CurrentRuby.parse(File.read(f))
       find_requires(ast) do |require_resource|
         to = make_safe_for_graphviz(require_resource)
         puts "\t#{from} -> #{to}"
       end
     end

     puts "}"

     exit_success!
   end
 }
 
