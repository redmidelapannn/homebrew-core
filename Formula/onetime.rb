class Onetime < Formula
  desc "Encryption with one-time pads"
  homepage "http://red-bean.com/onetime/"

  stable do
    url "http://red-bean.com/onetime/onetime-1.81.tar.gz"
    sha256 "36a83a83ac9f4018278bf48e868af00f3326b853229fae7e43b38d167e628348"

    # Fixes the Makefile to permit destination specification
    # https://github.com/kfogel/OneTime/pull/12
    patch do
      url "https://github.com/kfogel/OneTime/commit/61e534e2.patch"
      sha256 "2c22ca15dd61448d71515ce7e03b7e05d38450fd59b673323c47ade7023cb64c"
    end

    # Follow up to PR12 to fix my clumsiness in a variable call.
    patch do
      url "https://github.com/kfogel/OneTime/commit/fb0a12f2.patch"
      sha256 "68be20314f513d126287e7d799dc6c57fb0ece4d28b85588c102a5144422bc80"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "1d63d7f0e97e538b0d20ae33a9b44a3539a5c604f2cd1ac8b74f1440a7ac8548" => :sierra
    sha256 "1d63d7f0e97e538b0d20ae33a9b44a3539a5c604f2cd1ac8b74f1440a7ac8548" => :el_capitan
    sha256 "1d63d7f0e97e538b0d20ae33a9b44a3539a5c604f2cd1ac8b74f1440a7ac8548" => :yosemite
  end

  devel do
    url "http://red-bean.com/onetime/onetime-2.0-beta15.tar.gz"
    # FIXME: I can't rememeber why the custom version was added now, but
    # we're stuck with it now as 2.0-beta(n) is "less" than 2.0.0(n).
    version "2.0.15"
    sha256 "7f3678a70f6b83fdd961c1aa9795ee513afffb6e8684d28179cbac63add5d8f2"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "dd", "if=/dev/random", "of=pad_data.txt", "bs=1024", "count=1"
    (testpath/"input.txt").write "INPUT"
    system bin/"onetime", "-e", "--pad=pad_data.txt", "--no-trace",
                          "--config=.", "input.txt"
    system bin/"onetime", "-d", "--pad=pad_data.txt", "--no-trace",
                          "--config=.", "input.txt.onetime"
  end
end
