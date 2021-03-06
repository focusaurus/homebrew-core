require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.7.tar.gz"
  sha256 "67ffa0385a83c611e0e7bf7f8d3105f626b24d94c7f753645d55b0d0fd8f53e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bd313740e10757294d520da94d948640ceed039bbe2d18078433ff9a1d49114" => :catalina
    sha256 "a1eac5f81e5e981ac77cb4bdf35f593f14c874f560b4305dfd2a2aefc26cfdd9" => :mojave
    sha256 "79fed0ab543f61b75aa424680dd685545e62f041a01f11bbf9afe1b5216de6df" => :high_sierra
  end

  depends_on "haskell-stack" => :build

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
