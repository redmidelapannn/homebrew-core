# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Gfile < Formula
  desc "Direct file transfer over WebRTC"
  homepage "https://github.com/Antonito/gfile"
  url "https://github.com/Antonito/gfile/releases/download/v0.1.0/gfile_Darwin_x86_64.tar.gz"
  sha256 "a386af795bd1dfa4c1132390c0eb91b82c661bd4c49f176626746cea1f5767ce"
  bottle do
    cellar :any_skip_relocation
    sha256 "3cdb8fa06a3f7cf8e2c71a1aa74411511dac35d8f0a76ec8673fa79d43780a54" => :mojave
    sha256 "3cdb8fa06a3f7cf8e2c71a1aa74411511dac35d8f0a76ec8673fa79d43780a54" => :high_sierra
    sha256 "d51e50e494d0269682384898a6f06f14ea21e3ebf22f0422e827e3da2a0921a9" => :sierra
  end

  # depends_on "cmake" => :build

  def install
	bin.install "gfile"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test gfile`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
