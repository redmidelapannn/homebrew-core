class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.3.0/nvc-1.3.0.tar.gz"
  sha256 "6c98468ba73558c454176f5176a4c63c85bdc3c930be6f77fa3b7efb3aa8ddb8"

  bottle do
    sha256 "d4502cb577850cd0f44c790c9eb86daed6ac3a6258ea48911812993b9b5dfd7e" => :high_sierra
    sha256 "afec10d1a57f5acc58a1e69d8886fb785e1ba90323c4ebac0e8ec4ccae495b93" => :sierra
    sha256 "06ec647b83c692ef0920d85e7f6d599ea8ac9e775189d36b8ccb25ef6611ac84" => :el_capitan
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    # Fix "error: use of undeclared identifier 'CLOCK_MONOTONIC'"
    # Reported 1 Jan 2018 https://github.com/nickg/nvc/issues/365
    if MacOS.version <= :el_capitan
      inreplace "src/rt/rtkern.c",
                /(static uint64_t rt_timestamp_us\(void\)\n{\n)#ifndef _WIN32/,
                "\\1#ifdef _WIN32"
    end

    system "./autogen.sh" if build.head?

    # avoid hard-coding the superenv shim path
    cc_bare = Utils.popen_read("sh -ilc 'which #{ENV["CC"]}'").chomp
    inreplace "configure", 'cc_bare="$(which ${CC%% *})"', "cc_bare=\"#{cc_bare}\""

    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
