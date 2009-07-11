require 'pathname'
require 'rubygems'
require 'hoe'

ROOT    = Pathname(__FILE__).dirname.expand_path
JRUBY   = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO    = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])

require ROOT + 'lib/dm-is-published/is/version'

# define some constants to help with task files
GEM_NAME    = 'dm-is-published'
GEM_VERSION = DataMapper::Is::Published::VERSION

Hoe.new(GEM_NAME, GEM_VERSION) do |p|
  p.developer('Kematzy', 'kematzy gmail com')

  p.description = 'A DataMapper plugin provides an easy way to add different states to your models.'
  p.summary = 'A DataMapper plugin provides an easy way to add different states to your models.'
  p.url = 'http://github.com/kematzy/dm-is-published'

  p.clean_globs |= %w[ log pkg coverage ]
  p.spec_extras = { :has_rdoc => true, :extra_rdoc_files => %w[ README.txt LICENSE TODO History.txt ] }

  p.extra_deps << ['dm-core', "~>  DMGen::DM_VERSION"]

end

Pathname.glob(ROOT.join('tasks/**/*.rb').to_s).each { |f| require f }
