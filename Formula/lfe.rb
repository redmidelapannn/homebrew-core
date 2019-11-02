class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.3.tar.gz"
  sha256 "1946c0df595ae49ac33fe583f359812dec6349da6acf43c1458534de3267036b"
  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "28c56a76c960e69e5952ef08a159fc1bde0d487474f1ad4242f452cfbd4d6ff8" => :catalina
    sha256 "e5078d125a96ef14019a317fcee83ed19867c476bd28f12f44e2e1e43a3e3d4a" => :mojave
    sha256 "2a315206b6e2fe030ffca558b0d0c08c902d84c60ff73e5b5ba3876407ee375c" => :high_sierra
  end

  depends_on "erlang"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    doc.install Dir["doc/*.txt"]
    pkgshare.install "dev", "examples", "test"

    if MacOS.version <= :mojave
      system "make", "emacs"
      elisp.install Dir["emacs/*.elc"]
    end
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
