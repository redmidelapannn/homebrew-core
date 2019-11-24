class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "https://0install.net/"
  url "https://downloads.sf.net/project/zero-install/0install/2.14.1/0install-2.14.1.tar.bz2"
  sha256 "7c389eef002e4849b37c9f2438679723266948191f5bcb09879c1cd5827533c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "963ebbbcd5e0e7e569693e0d408803b77acf27581754ce661a863b20eb67461b" => :catalina
    sha256 "816eb1856de1e0c97e7297bcfc85e4bd2c2e6e588e47ece48f9ad166dc5d98d2" => :mojave
    sha256 "32e83ab42128bcdbeaadf189cb9a9af49a9a6940be29550e5f39ea23d16e0672" => :high_sierra
  end

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "gnupg"

  def install
    ENV.append_path "PATH", Formula["gnupg"].opt_bin
    
    # Use correct curl headers
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      modules = %w[
        cppo
        yojson
        xmlm
        ounit
        lwt_react
        ocurl
        sha
        dune
      ]
      system "opam", "config", "exec", "opam", "install", *modules

      # mkdir: <buildpath>/build: File exists.
      # https://github.com/0install/0install/issues/87
      ENV.deparallelize { system "opam", "config", "exec", "make" }

      inreplace "dist/install.sh" do |s|
        s.gsub! '"/usr/local"', prefix
        s.gsub! '"${PREFIX}/man"', man
      end
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.py").write <<~EOS
      print("hello world")
    EOS
    (testpath/"hello.xml").write <<~EOS
      <?xml version="1.0" ?>
      <interface xmlns="http://zero-install.sourceforge.net/2004/injector/interface">
        <name>Hello</name>
        <summary>minimal demonstration program</summary>

        <implementation id="." version="0.1-pre">
          <command name='run' path='hello.py'>
            <runner interface='http://repo.roscidus.com/python/python'></runner>
          </command>
        </implementation>
      </interface>
    EOS
    assert_equal "hello world\n", shell_output("#{bin}/0launch --console hello.xml")
  end
end
