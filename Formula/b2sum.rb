class B2sum < Formula
  desc "BLAKE2 b2sum reference binary"
  homepage "https://github.com/BLAKE2/BLAKE2"
  url "https://github.com/BLAKE2/BLAKE2/archive/20160619.tar.gz"
  sha256 "cbac833ccae56b5c6173dbeaf871aa99b32745cf7a994c7451d4533ecda55633"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3b36b9220ed4e19e5fc943d439ed467e6501139ec9a426a5486a0873c5abaf05" => :mojave
    sha256 "5d2986826bac2a327a00f5e704c94a6abd178e9abb26f61a90ad3232cac72571" => :high_sierra
    sha256 "113f58e2bfa748263048a38ceb06b9ce9b157c39c72a387e3e424bbb47553c4f" => :sierra
    sha256 "b4a644160ecdf8ebf8e1d1014ceb706790198e691b296d3643daf7bd38460eed" => :el_capitan
  end

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
