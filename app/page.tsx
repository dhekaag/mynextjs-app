import { MultiLanguageTypewriter } from "@/components/ui/multi-language-typewriter";

export default function Home() {
  return (
    <div className="relative min-h-screen">
      {/* Main Content */}
      <main className="flex min-h-screen items-center justify-center px-8">
        <div className="flex flex-col items-center gap-8">
          {/* Multi-language Typewriter */}
          <div className="flex flex-col items-center gap-4">
            <MultiLanguageTypewriter
              className="justify-center"
              textClassName="text-white"
            />
            <h2 className="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-bold text-white">
              I&apos;m Agung Dwi Kurniyanto
            </h2>
          </div>

          {/* Subtitle */}
          <p className="text-base sm:text-lg md:text-xl text-gray-300 text-center max-w-2xl">
            2210512007 - Cloud Computing Class
          </p>
        </div>
      </main>
    </div>
  );
}
