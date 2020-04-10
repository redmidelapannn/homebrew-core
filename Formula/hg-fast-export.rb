class HgFastExport < Formula
  include Language::Python::Virtualenv

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v200213.tar.gz"
  sha256 "358f501ab301c31525f23f29e94708fe361ed53e99b5fb9c77fbca81ff1a2b76"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4eaaec71bbe58d3c4ed753cb90e636824bf3f3956aa69a5d96c27baa5410018a" => :catalina
    sha256 "3f0fdac5a2d7b1d34cb338f1ad06ae8cba4badf17054c27828a50b21aa816f12" => :mojave
    sha256 "36539d8a28db2515735dddaf25a5cc1c4872c1ba91a7e41b3f8e653b7a63f64c" => :high_sierra
  end

  depends_on :macos # Due to Python 2

  # mercurial 5.3 support will be added in the next release
  # Ref https://github.com/frej/fast-export/pull/197
  resource "hg" do
    url "https://www.mercurial-scm.org/release/mercurial-5.2.2.tar.gz"
    sha256 "ffc5ff47488c7b5dae6ead3d99f08ef469500d6567592a25311838320106c03b"
  end

  def install
    ENV.delete("PYTHONPATH")
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("hg").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }

    libexec.install Dir["*"]

    bins = %w[hg-fast-export.py hg-fast-export.sh hg-reset.py hg-reset.sh hg2git.py]
    bins.each do |f|
      (bin / f).write_env_script(libexec / f, :PYTHONPATH => ENV["PYTHONPATH"])
    end
  end

  test do
    hg = "#{libexec}/vendor/bin/hg"

    mkdir testpath/"hg-repo" do
      system hg, "init"
      (testpath/"hg-repo/test.txt").write "Hello"
      system hg, "add", "test.txt"
      system hg, "commit", "-u", "test@test", "-m", "test"
    end

    mkdir testpath/"git-repo" do
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system "hg-fast-export.sh", "-r", "#{testpath}/hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_predicate testpath/"git-repo/test.txt", :exist?
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
