"use client";

import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";

interface Language {
  hello: string;
  flag: string;
}

const languages: Language[] = [
  { hello: "Halo", flag: "🇮🇩" }, // Indonesia
  { hello: "Hello", flag: "🇬🇧" }, // English
  { hello: "こんにちは", flag: "🇯🇵" }, // Japanese
  { hello: "Bonjour", flag: "🇫🇷" }, // French
];

export const MultiLanguageTypewriter = ({
  className,
  textClassName,
}: {
  className?: string;
  textClassName?: string;
}) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [displayText, setDisplayText] = useState("");
  const [isDeleting, setIsDeleting] = useState(false);
  const [loopNum, setLoopNum] = useState(0);
  const [typingSpeed, setTypingSpeed] = useState(150);

  useEffect(() => {
    const currentLanguage = languages[currentIndex];
    const fullText = currentLanguage.hello;

    const handleType = () => {
      if (!isDeleting) {
        // Typing
        if (displayText.length < fullText.length) {
          setDisplayText(fullText.substring(0, displayText.length + 1));
          setTypingSpeed(150);
        } else {
          // Pause before deleting
          setTimeout(() => setIsDeleting(true), 2000);
        }
      } else {
        // Deleting
        if (displayText.length > 0) {
          setDisplayText(fullText.substring(0, displayText.length - 1));
          setTypingSpeed(100);
        } else {
          setIsDeleting(false);
          setCurrentIndex((prev) => (prev + 1) % languages.length);
          setLoopNum(loopNum + 1);
        }
      }
    };

    const timer = setTimeout(handleType, typingSpeed);
    return () => clearTimeout(timer);
  }, [displayText, isDeleting, currentIndex, typingSpeed, loopNum]);

  return (
    <div className={cn("inline-flex items-center gap-3", className)}>
      <AnimatePresence mode="wait">
        <motion.span
          key={currentIndex}
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          exit={{ scale: 0.8, opacity: 0 }}
          transition={{ duration: 0.3 }}
          className="text-xl sm:text-2xl md:text-3xl"
        >
          {languages[currentIndex].flag}
        </motion.span>
      </AnimatePresence>
      <span
        className={cn(
          "text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-bold",
          textClassName
        )}
      >
        {displayText}
        {/* <motion.span
          animate={{ opacity: [0, 1, 0] }}
          transition={{ duration: 0.8, repeat: Infinity }}
          className="inline-block w-1 h-6 sm:h-8 md:h-10 lg:h-12 bg-white ml-1"
        /> */}
      </span>
    </div>
  );
};
