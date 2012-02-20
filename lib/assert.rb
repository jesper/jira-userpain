#based on an email from Ned Konz | http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/41639

class AssertionFailure < StandardError
end

class Object
  def assert(bool, message = 'assertion failure')
    raise AssertionFailure.new(message) unless bool
  end
end
