class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/b6/d6/be8f975f5322336f62371c9abeb936d592c98c047ad63035f1b38ae08efe/numpy-1.17.3.zip"
  sha256 "a0678793096205a4d784bd99f32803ba8100f639cf3b932dc63b21621390ea7e"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "05a45acb7ca4f1635b32841b6c6733c4051ed509851574d3bee37d1fc324ddc5" => :catalina
    sha256 "5829c43dafaef59ddaec17d5fdfc0143fe10140604a631a19cbd7cb33328149e" => :mojave
    sha256 "bdf92c140dba3d74705412f589e03c5386071c033d89a88dee851b823af1cafc" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python"

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/libopenblas.dylib"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{version}/site-packages"

    system "python3", "setup.py",
      "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
