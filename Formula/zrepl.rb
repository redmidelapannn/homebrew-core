class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/0.1.0-rc3.tar.gz"
  head "https://github.com/zrepl/zrepl.git"
  sha256 "09b4eb2b160c131a23e45f7b786d2103b362b5802a4b65b6e764243a1afe2ed6"
  depends_on "go" => :build
  depends_on "python3" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/zrepl/zrepl").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"
    
    cd gopath/"src/github.com/zrepl/zrepl" do
      system "./lazy.sh",  "godep"
      system "make", "ZREPL_VERSION=0.1.0"
      bin.install "artifacts/zrepl"
    end      
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test zrepl`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
