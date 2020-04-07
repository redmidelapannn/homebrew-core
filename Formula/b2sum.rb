class B2sum < Formula
  desc "BLAKE2 b2sum reference binary"
  homepage "https://github.com/BLAKE2/BLAKE2"
  url "https://github.com/BLAKE2/BLAKE2/archive/20160619.tar.gz"
  sha256 "cbac833ccae56b5c6173dbeaf871aa99b32745cf7a994c7451d4533ecda55633"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "10d4524797efd7f0e717845641a95b73122a3257d01f5cfa5dc0bd498554341e" => :catalina
    sha256 "3f6fa6acbd775090d2c164de07d22ffe4c9834c132574e4736e978cbb763efe7" => :mojave
    sha256 "ab129a8588e41cacca7434af16f9340b335c54f9d665e0267b6539ad45b25bec" => :high_sierra
  end

  conflicts_with "coreutils", :because => "both install `b2sum` binaries"

  def install
    cd "b2sum" do
      system "make", "NO_OPENMP=1"
      system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
    end
  end

  test do
    checksum = <<~EOS
      ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d17d87c5392
      aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923  -
    EOS
    assert_equal checksum.delete!("\n"),
                 pipe_output("#{bin}/b2sum -", "abc").chomp
  end
end
