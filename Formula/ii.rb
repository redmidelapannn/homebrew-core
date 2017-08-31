class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-1.7.tar.gz"
  sha256 "3a72ac6606d5560b625c062c71f135820e2214fed098e6d624fc40632dc7cc9c"
  head "https://git.suckless.org/ii", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "298b082d44429789da8d6a2bdfbca88c2bfad41a1c177b536da6e3b98a12c668" => :sierra
    sha256 "61a12416b83a9be2a393b7c45c0b3ca581ebe6800dd1ec0c151f14268bdba089" => :el_capitan
    sha256 "44cd54e3d8e5818a06e18a67bc672ead34e63f6796979f45125bd9706ba492c9" => :yosemite
  end

  def install
    inreplace "config.mk" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "cc", ENV.cc
    end
    system "make", "install"
  end
end
