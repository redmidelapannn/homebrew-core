class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag      => "v0.8.1",
      :revision => "d6574a5bb1226678d7010325fb6c985db20ee458"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "44dde37a169f916694c10569909403448287c4da8f1493abf1fecc2d5e8b0782" => :mojave
    sha256 "8ddceb7fc430defa134668ba2a70afc49924a910700c9f0981a7ad88593b8fee" => :high_sierra
    sha256 "216231775c4473aa7501ff3346c38014085dba82d041d0212ed8113c6aa47cd0" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build
  depends_on "gox" => :build

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/serf").install contents

    ENV["GOPATH"] = gopath
    ENV["XC_ARCH"] = "amd64"
    ENV["XC_OS"] = "darwin"

    (gopath/"bin").mkpath

    cd gopath/"src/github.com/hashicorp/serf" do
      system "make", "bin"
      bin.install "bin/serf"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/serf", "agent"
      end
      sleep 1
      assert_match /:7946.*alive$/, shell_output("#{bin}/serf members")
    ensure
      system "#{bin}/serf", "leave"
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
