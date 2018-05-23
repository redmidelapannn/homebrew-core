class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
    :tag => "v7.0.1",
    :revision => "add59f4e5f067a0d6ceb53aefd57aaa3eee50e88"
  head "https://github.com/tsenart/vegeta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0db9dc10d38d2c25f2245aa4861dfcc14767a75dc8e0b57246faeac373552275" => :high_sierra
    sha256 "2379bcd241b518a6620b1d2bb1b7b7b3cbfa729e478c48af55dd96bb8a9922ea" => :sierra
    sha256 "fe46d3396310058ff137c8e01ce2d003e58edb0ec466bd55abdef6757c969c2c" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOPATH"] = buildpath

    dir = buildpath / "src/github.com/tsenart/vegeta"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure"

      commit = Utils.popen_read("git rev-parse HEAD").chomp
      date = Time.now.strftime("%FT%T%:z") # e.g 2007-11-19T08:37:48-06:00
      system "go", "build", "-o", bin / "vegeta",
             "-a", '-tags="netgo"',
             "-ldflags", %Q(-s -w -extldflags "-static" -X main.Version=#{version} -X main.Commit=#{commit} -X main.Date=#{date})

      prefix.install_metafiles
    end
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
