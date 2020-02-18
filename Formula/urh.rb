class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/d9/73/f64e4951072fb2781a05e86694ce840c1e1b16088c8fdeff2ea78ca612d6/urh-2.8.2.tar.gz"
  sha256 "2ec38491c0e3235936f4e4f742841942c2cfcb6269ae9dbd47730ef806285e25"
  revision 1
  head "https://github.com/jopohl/urh.git"

  bottle do
    sha256 "86ca73d7fbf9f4dccd51d3a70e14fc6430a4b664f55e7886be4d069444cb3a26" => :catalina
    sha256 "8bab01f2c3ebebc799afa753e44dc4f0a8911dd216bc493b586a19fe920618c2" => :mojave
    sha256 "6678e10a9bd4f384157d6bbc3ed143b9affa803a7dd68cf22e33db9d7d8c3a4f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python"
  depends_on "zeromq"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/9c/9b/706dac7338c2860cd063a28cdbf5e9670995eaea408abbf2e88ba070d90d/Cython-0.29.14.tar.gz"
    sha256 "e4d6bb8703d0319eb04b7319b12ea41580df44fd84d83ccda13ea463c6801414"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/93/4f8213fbe66fc20cb904f35e6e04e20b47b85bee39845cc66a0bcf5ccdcb/psutil-5.6.7.tar.gz"
    sha256 "ffad8eb2ac614518bbe3c0b8eb9dffdb3a8d2e3a7d5da51c5b974fb723a5c5aa"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/3c/83/7ecbe9b762829f589fa9734026e0ccb63cb128fe5615ae1698f65df72bfe/pyzmq-18.1.1.tar.gz"
    sha256 "8c69a6cbfa94da29a34f6b16193e7c15f5d3220cb772d6d17425ff3faa063a6d"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      next if r.name == "Cython"

      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    saved_python_path = ENV["PYTHONPATH"]
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{xy}/site-packages"

    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"cython")
    end

    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => saved_python_path)
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    (testpath/"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system "python3", "test.py"
  end
end
