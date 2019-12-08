class B43Fwcutter < Formula
  desc "Extract firmware from Braodcom 43xx driver files"
  homepage "https://wireless.kernel.org/en/users/Drivers/b43"
  url "https://bues.ch/b43/fwcutter/b43-fwcutter-019.tar.bz2"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/b43-fwcutter_019.orig.tar.bz2"
  sha256 "d6ea85310df6ae08e7f7e46d8b975e17fc867145ee249307413cfbe15d7121ce"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "35ead205439c8524a888745983dc453b4347c5c8b04740e679783ee30765f9f3" => :catalina
    sha256 "ed1e145b285e406005d359a2fbc1908c29eb2659f8ea0cfe31bba60bf8ca6831" => :mojave
    sha256 "15685da9138932e65048cacb40654e6bccd12d1e25580a970fdb820de5523939" => :high_sierra
  end

  def install
    inreplace "Makefile" do |m|
      # Don't try to chown root:root on generated files
      m.gsub! /install -o 0 -g 0/, "install"
      m.gsub! /install -d -o 0 -g 0/, "install -d"
      # Fix manpage installation directory
      m.gsub! "$(PREFIX)/man", man
    end
    # b43-fwcutter has no ./configure
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/b43-fwcutter", "--version"
  end
end
