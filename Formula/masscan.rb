class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/1.0.4.tar.gz"
  sha256 "51de345f677f46595fc3bd747bfb61bc9ff130adcbec48f3401f8057c8702af9"
  head "https://github.com/robertdavidgraham/masscan.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5a21b86b9721dd3d15c61db4d6f6fbeb3b381ee51c4dcab3bcb693ded7292b54" => :high_sierra
    sha256 "3b1f42f36336fde9860c5f164b5964cc33f5a2cd9a1c8c13346e44faeb9b9490" => :sierra
    sha256 "fa3deced0f8b627fa8124ab630123b4b937f1c956977229e9b10e3017291f0bd" => :el_capitan
  end

  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://github.com/robertdavidgraham/masscan/pull/282.patch?full_index=1"
      sha256 "0daa190200f5cf3e11e9e1c29ea65e7e8e8c0b13fbeccf9a2319cb166234d684"
    end
  end

  def install
    # Fix `dyld: lazy symbol binding failed: Symbol not found: _clock_gettime`
    # Reported 8 July 2017: https://github.com/robertdavidgraham/masscan/issues/284
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "src/pixie-timer.c", "#elif defined(CLOCK_MONOTONIC)", "#elif defined(NOT_A_MACRO)"
    end

    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert_match(/adapter =/, `#{bin}/masscan --echo | head -n 6 | tail -n 1`)
  end
end
