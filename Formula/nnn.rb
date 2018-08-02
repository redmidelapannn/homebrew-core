class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.8.tar.gz"
  sha256 "65c364a9797178e40ec7ec653b2cfa8e211e556b75250bf72eb5eea57f5e0cdc"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "018cfbb07bcea1bed70b908f701cd0b81429ac4e818854525a6644009450d674" => :high_sierra
    sha256 "ce8ab63ab80be5c6350ae66bd3a51b049da80af69d008091072b9473e4209239" => :sierra
    sha256 "9fc58eaa0dda1b7dd7dd3c0d94670b06111bb2bc63b44011ded610c975643b14" => :el_capitan
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
