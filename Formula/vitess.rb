class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "http://vitess.io"

  url "https://github.com/arthurnn/vitess.git",
      :revision => "75b5eb418f2b5d5ac1e8f5f8fd6bad723d0dcd48",
      :branch => "arthurnn/easier_build"
  version "2.1.1.75b5eb41"
  head "https://github.com/arthurnn/vitess.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bd2523346d6d921823026008d96d9dae92f1a2d9ab85b8cf6603db2411a594d" => :high_sierra
    sha256 "fe7a9b11a0b3a63f21a88300a9344adafc656abd0eeab1b1b05dc312b9f36abc" => :sierra
    sha256 "77950990144baab8a9f948e2302130fffd27fe2206c3b613c20d8791b36e4c14" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/github.com/youtube/vitess").install contents

    cd "src/github.com/youtube/vitess" do
      system "make", "build"
      prefix.install "web"
    end

    %w[vtclient
       vtcombo
       vtctl
       vtctlclient
       vtctld
       vtexplain
       vtgate
       vtqueryserver
       vttablet
       vtworker
       vtworkerclient].each do |binary|
      bin.install "bin/#{binary}"
    end
  end

  test do
    begin
      pid = fork do
        exec bin/"vtcombo",
             "-port=15900",
             "-mycnf_server_id", "1",
             "-web_dir", "#{prefix}/web/vtctld",
             "-web_dir2", "#{prefix}/web/vtctld2/app"
      end
      sleep 1
      output = shell_output("curl -I 127.0.0.1:15900/app2/")
      assert_match "200 OK", output
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
