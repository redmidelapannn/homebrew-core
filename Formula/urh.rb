class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/df/f9/b58b2c73c32ea153926049819bca96c3da85725b915a81d5ae810d649cc4/urh-2.7.3.tar.gz"
  sha256 "dabb10db83134baf1b31c32d683480db752cecb43bcb35b8bd319870dfb81997"
  head "https://github.com/jopohl/urh.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6c3adad798551c02d0f032bb4aa605ee9aa5fe6e3bc1545b66d2314f34645712" => :mojave
    sha256 "02b56d2752c2e3f972c24cf08ef6d516ffd5f82b191834e27be1e61f369b6f32" => :high_sierra
    sha256 "26a380a8bc363c10c56ce1aaf7662c876f67700b80c02b64390ed84c1d6565fe" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python"
  depends_on "zeromq"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/5b/5b/6cba7123a089c4174f944dd05ea7984c8d908aba8746a99f2340dde8662f/Cython-0.29.12.tar.gz"
    sha256 "20da832a5e9a8e93d1e1eb64650258956723940968eb585506531719b55b804f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1c/ca/5b8c1fe032a458c2c4bcbe509d1401dca9dda35c7fc46b36bb81c2834740/psutil-5.6.3.tar.gz"
    sha256 "863a85c1c0a5103a12c05a35e59d336e1d665747e531256e061213e2e90f63f3"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/a8/5e/7e4ed045fc1fb7667de4975fe8b6ab6b358b16bcc59e8349c9bd092931b6/pyzmq-18.0.2.tar.gz"
    sha256 "31a11d37ac73107363b47e14c94547dbfc6a550029c3fe0530be443199026fc2"
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
