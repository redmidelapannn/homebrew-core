class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag => "3.43",
      :revision => "a513685ebefd5f5dc78caff6272f5a7d2d692e1d"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3cfe843200dc5b987ba60b19987eb109162e15556e114472f4f0f4c4a6ca6fa7" => :high_sierra
    sha256 "a9ba8e5741710af5c234084ce6ef570293926bf5534c9616cdd20d867579473a" => :sierra
    sha256 "e1e5235cabd1dc5e66726d421f2e71f0ad710fc2919ffa00cdb551b580c8089a" => :el_capitan
  end

  option "without-cython", "Build without cython (faster compile)"

  depends_on "python@2"
  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "cython" => [:build, :recommended]

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"

    if build.with? "cython"
      pyincludes = Utils.popen_read("python-config --cflags").chomp
      pylib = Utils.popen_read("python-config --ldflags").chomp
      system "make", "install-cyreposurgeon", "prefix=#{prefix}",
                     "CYTHON=#{Formula["cython"].opt_bin}/cython",
                     "pyinclude=#{pyincludes}", "pylib=#{pylib}"
    end
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
