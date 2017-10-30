class Hatop < Formula
  desc "Interactive ncurses client for HAProxy"
  homepage "http://feurix.org/projects/hatop/"
  url "https://github.com/feurix/hatop/archive/v0.7.7.tar.gz"
  sha256 "497a28e484940bf2f6dd5919041d5d03025325a59e8f95f376f573db616ca35d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e410318f6bbd5b5bc719a81957b4cfb9eb5f1c58826be8f7da7c11958cf447e" => :high_sierra
    sha256 "1e410318f6bbd5b5bc719a81957b4cfb9eb5f1c58826be8f7da7c11958cf447e" => :sierra
    sha256 "1e410318f6bbd5b5bc719a81957b4cfb9eb5f1c58826be8f7da7c11958cf447e" => :el_capitan
  end

  def install
    man1.install "man/hatop.1"
    bin.install "bin/hatop"
  end

  test do
    system bin/"hatop", "--version"
  end
end
