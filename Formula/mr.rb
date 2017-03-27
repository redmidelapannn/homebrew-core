class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "https://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/", :tag => "1.20170129", :revision => "60e9c44a2c2cc884988324aec452e11339d7b20b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9e8ee6fc7e25a9e914c9e35ac7dc7cfda50ef5bd251aedda89e49164675ba852" => :sierra
    sha256 "34574262d16d05364ae0973ac13530d6f064578422667a2bd2617529a08c30bd" => :el_capitan
    sha256 "717d04b8d6782299ce288ee1e939b4403dd764fb95471172d05bb8a271ba8580" => :yosemite
  end

  resource("test-repo") do
    url "https://github.com/Homebrew/homebrew-command-not-found.git"
  end

  def install
    system "make"
    bin.install "mr", "webcheckout"
    man1.install gzip("mr.1", "webcheckout.1")
    pkgshare.install Dir["lib/*"]
  end

  test do
    resource("test-repo").stage do
      system bin/"mr", "register"
      assert_match(/^mr status: #{Dir.pwd}$/, shell_output("#{bin}/mr status"))
    end
  end
end
