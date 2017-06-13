class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.1.0.tar.gz"
  sha256 "db7afe24d859b9c8230c3491640d996701816ddc9cf66f98a5071775e8b4ffe5"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4bd0fee98c7b59b4f92492850eb238dd7b84cb0b0dda31b52cb452383dac7859" => :sierra
    sha256 "0e8245ebe1e6c153b06c16914fa07ea9cf3efdf9e2991caf8ed95a07c012cf4e" => :el_capitan
    sha256 "0e8245ebe1e6c153b06c16914fa07ea9cf3efdf9e2991caf8ed95a07c012cf4e" => :yosemite
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    inreplace "Makefile", "$(DESTDIR)/etc", "$(DESTDIR)$(SYSCONFDIR)"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
