class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  url "https://github.com/ncbi/sra-tools/archive/2.8.2-5.tar.gz"
  version "2.8.2-5"
  sha256 "15b41420d95a72de9e24dec53401cc10e435a17ee9c5eec45ef78fd078db544c"
  head "https://github.com/ncbi/sra-tools.git"
  revision 1

  bottle do
    cellar :any
    sha256 "540feac5b3d1d482fef2b347256b2144d3eaae0fdc4e4d77a199b5cfd034de5b" => :high_sierra
    sha256 "cc5718ab002cb8d4dd42e3d50b6d10efe01752594b5ee00496fedcd59d6963de" => :sierra
    sha256 "793828d3c8eb604c44ccff819463f50b9d914f4d000f5f655dae2952e52232c3" => :el_capitan
  end

  depends_on "hdf5"
  depends_on "libmagic"

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/1.3.0.tar.gz"
    sha256 "803c650a6de5bb38231d9ced7587f3ab788b415cac04b0ef4152546b18713ef2"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.8.2-2.tar.gz"
    version "2.8.2-2"
    sha256 "7866f7abf00e35faaa58eb3cdc14785e6d42bde515de4bb3388757eb0c8f3c95"
  end

  # Replace the konfigure.perl that ships with sra-tools and ncbi-vdb with a dev one
  # that can detect and add the required hdf5 libraries.
  # Issue: https://github.com/Linuxbrew/homebrew-core/issues/5323
  resource "ncbi-hdf5-detection" do
    url "https://raw.githubusercontent.com/ncbi/ncbi-vdb/46c85bf711429542f4eb6d8fe0f90493cdf079be/setup/konfigure.perl"
    version "46c85bf711429542f4eb6d8fe0f90493cdf079be"
    sha256 "8a1dc35fc4c8cfa6bcc803cb7b4668813f953530398c8024ce558e4a67075a5c"
  end

  def install
    resource("ncbi-hdf5-detection").stage do
      cp "konfigure.perl", buildpath/"konfigure.perl"
    end

    ngs_sdk_prefix = buildpath/"ngs-sdk-prefix"
    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure",
          "--prefix=#{ngs_sdk_prefix}",
          "--build=#{buildpath}/ngs-sdk-build"
        system "make"
        system "make", "install"
      end
    end

    ncbi_vdb_source = buildpath/"ncbi-vdb-source"
    ncbi_vdb_build = buildpath/"ncbi-vdb-build"
    ncbi_vdb_source.install resource("ncbi-vdb")
    cd ncbi_vdb_source do
      # Fix the konfigure
      cp buildpath/"konfigure.perl", "setup/konfigure.perl"
      system "./configure",
        "--prefix=#{buildpath/"ncbi-vdb-prefix"}",
        "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
        "--build=#{ncbi_vdb_build}"
      ENV.deparallelize { system "make" }
    end

    # Fix the error: ld: library not found for -lmagic-static
    # Upstream PR: https://github.com/ncbi/sra-tools/pull/105
    inreplace "tools/copycat/Makefile", "-smagic-static", "-smagic"

    # Fix the konfigure
    cp buildpath/"konfigure.perl", "setup/konfigure.perl"

    system "./configure",
      "--prefix=#{prefix}",
      "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
      "--with-ncbi-vdb-sources=#{ncbi_vdb_source}",
      "--with-ncbi-vdb-build=#{ncbi_vdb_build}",
      "--build=#{buildpath}/sra-tools-build"

    ENV.deparallelize
    system "make", "install"

    # Remove non-executable files.
    rm_r [bin/"magic", bin/"ncbi"]
  end

  test do
    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
