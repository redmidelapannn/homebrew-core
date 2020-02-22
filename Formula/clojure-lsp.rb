class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  url "https://github.com/snoe/clojure-lsp/archive/release-20190408T040839.tar.gz"
  version "20190408"
  sha256 "79c6d812a8ef4af2cfdd78c4b9aa96674ff9fb8dfeb27869215caa4aee954fae"
  revision 1
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c2bec959322ea41331ae1231bc364bedaafc5ca5e22240a1a73ed904644e52b" => :catalina
    sha256 "ac2b9d93412cc2861a596a691c0777a9196a82ef26611337b2fa2544a0878de8" => :mojave
    sha256 "97f39ee9a6f9462912d3496d5e3fb986d51a9cd6509f75e3f20522831b513010" => :high_sierra
  end

  depends_on "leiningen" => :build
  depends_on "openjdk@11"

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    (bin/"clojure-lsp").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk@11"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/#{File.basename(jar)}" "$@"
    EOS
  end

  test do
    require "Open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/clojure-lsp")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 58

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Length", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
