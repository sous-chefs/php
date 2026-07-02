# frozen_string_literal: true

name 'php'

run_list 'test::default'

cookbook 'php', path: '.'
cookbook 'apt', git: 'https://github.com/sous-chefs/apt.git', branch: 'main'
cookbook 'ondrej_ppa_ubuntu', git: 'https://github.com/MelonSmasher/ondrej_ppa_ubuntu.git', branch: 'master'
cookbook 'test', path: './test/cookbooks/test'
cookbook 'yum', git: 'https://github.com/sous-chefs/yum.git', branch: 'main'
cookbook 'yum-epel', git: 'https://github.com/sous-chefs/yum-epel.git', tag: '5.0.9'
cookbook 'yum-remi-chef', '>= 5.0.1', git: 'https://github.com/sous-chefs/yum-remi-chef.git', tag: '5.0.1'

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, "test::#{recipe_name}"
end
