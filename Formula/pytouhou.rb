class Pytouhou < Formula
  desc "Libre implementation of Touhou 6 engine"
  homepage "https://pytouhou.linkmauve.fr/"
  url "https://hg.linkmauve.fr/touhou", :revision => "5270c34b4c00", :using => :hg
  version "634"
  revision 5
  head "https://hg.linkmauve.fr/touhou", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "fc2556c734d109e4adcaa28133a6a56d6fd1db74d8f891878ea9dbd7931f9470" => :mojave
    sha256 "8ccd9aec6ecf06a0b3c6f0cc3df8a11f5eb9338d69000426dea73f3018895007" => :high_sierra
    sha256 "7c3afbb4bf2a2e085b68bd558708cc3e232f426ec5024e7f15e07572d498a333" => :sierra
    sha256 "00924d059f6393ffc26e22419474469f593ce66e75674841d1f49fe330c517b6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libepoxy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b3/ae/971d3b936a7ad10e65cb7672356cff156000c5132cf406cb0f4d7a980fd3/Cython-0.28.3.tar.gz"
    sha256 "1aae6d6e9858888144cea147eb5e677830f45faaff3d305d77378c3cba55f526"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # hg can't determine revision number (no .hg on the stage)
    inreplace "setup.py", /(version)=.+,$/, "\\1='#{version}',"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    # Set default game path to pkgshare
    inreplace "#{libexec}/bin/pytouhou", /('path'): '\.'/, "\\1: '#{pkgshare}/game'"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<~EOS
    The default path for the game data is:
      #{pkgshare}/game
  EOS
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/pytouhou", "--help"
  end
end
