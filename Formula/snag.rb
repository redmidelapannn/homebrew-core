class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/v1.2.0.tar.gz"
  sha256 "37bf661436edf4526adf5428ac5ff948871c613ff4f9b61fbbdfe1fb95f58b37"
  head "https://github.com/Tonkpils/snag.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "898d501a742fb16d087937a0893eba538edc9d56bc4b6a25321aca983e68dc4f" => :high_sierra
    sha256 "4b057e5a98d5bd0f9c0523160c07da9419b894e6cbf5de235f4fd3013f360605" => :sierra
    sha256 "bc41e09d46808d9e4c723a0fb4d57605237aaa6c8c6c450f15ee67572ed653c0" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/Tonkpils/").mkpath
    ln_s buildpath, buildpath/"src/github.com/Tonkpils/snag"

    system "go", "build", "-o", bin/"snag", "./src/github.com/Tonkpils/snag"
  end

  test do
    (testpath/".snag.yml").write <<-EOS.undent
      build:
        - touch #{testpath}/snagged
      verbose: true
    EOS
    begin
      pid = fork do
        exec bin/"snag"
      end
      sleep 0.5
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
    assert_predicate testpath/"snagged", :exist?
  end
end
