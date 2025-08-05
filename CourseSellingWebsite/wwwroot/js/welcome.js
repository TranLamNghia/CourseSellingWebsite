// Global variables
let currentSlide = 0
const slides = document.querySelectorAll(".hero-bg")
const slideContents = document.querySelectorAll(".slide-content")
const heroImages = document.querySelectorAll(".hero-image")
const indicators = document.querySelectorAll(".indicator")
const totalSlides = slides.length

// Auto slide functionality
function nextSlide() {
  // Remove active class from current slide
  slides[currentSlide].classList.remove("active")
  slideContents[currentSlide].classList.remove("active")
  heroImages[currentSlide].classList.remove("active")
  indicators[currentSlide].classList.remove("active")

  // Move to next slide
  currentSlide = (currentSlide + 1) % totalSlides

  // Add active class to new slide
  slides[currentSlide].classList.add("active")
  slideContents[currentSlide].classList.add("active")
  heroImages[currentSlide].classList.add("active")
  indicators[currentSlide].classList.add("active")
}

// Initialize auto slide
let slideInterval = setInterval(nextSlide, 5000)

// Pause auto slide on hover
const heroSection = document.querySelector(".hero-section")
heroSection.addEventListener("mouseenter", () => {
  clearInterval(slideInterval)
})

heroSection.addEventListener("mouseleave", () => {
  slideInterval = setInterval(nextSlide, 5000)
})

// Manual slide control (optional - for future enhancement)
indicators.forEach((indicator, index) => {
  indicator.addEventListener("click", () => {
    if (index !== currentSlide) {
      slides[currentSlide].classList.remove("active")
      slideContents[currentSlide].classList.remove("active")
      heroImages[currentSlide].classList.remove("active")
      indicators[currentSlide].classList.remove("active")

      currentSlide = index

      slides[currentSlide].classList.add("active")
      slideContents[currentSlide].classList.add("active")
      heroImages[currentSlide].classList.add("active")
      indicators[currentSlide].classList.add("active")

      // Reset interval
      clearInterval(slideInterval)
      slideInterval = setInterval(nextSlide, 5000)
    }
  })
})

// Intersection Observer for scroll animations
const observerOptions = {
  threshold: 0.1,
  rootMargin: "0px 0px -50px 0px",
}

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add("animated")
    }
  })
}, observerOptions)

// Observe all elements with animate-on-scroll class
document.addEventListener("DOMContentLoaded", () => {
  const animateElements = document.querySelectorAll(".animate-on-scroll")
  animateElements.forEach((el) => {
    observer.observe(el)
  })
})

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
  anchor.addEventListener("click", function (e) {
    e.preventDefault()
    const target = document.querySelector(this.getAttribute("href"))
    if (target) {
      target.scrollIntoView({
        behavior: "smooth",
        block: "start",
      })
    }
  })
})

// Add staggered animation delays
document.addEventListener("DOMContentLoaded", () => {
  // Features section
  const featureCards = document.querySelectorAll(".features-section .feature-card")
  featureCards.forEach((card, index) => {
    card.style.animationDelay = `${index * 200}ms`
  })

  // Courses section
  const courseCards = document.querySelectorAll(".courses-section .course-card")
  courseCards.forEach((card, index) => {
    card.style.animationDelay = `${index * 200}ms`
  })

  // Why choose section
  const whyChooseCards = document.querySelectorAll(".why-choose-section .why-choose-card")
  whyChooseCards.forEach((card, index) => {
    card.style.animationDelay = `${index * 200}ms`
  })

  // Process section
  const processSteps = document.querySelectorAll(".process-section .process-step")
  processSteps.forEach((step, index) => {
    step.style.animationDelay = `${index * 200}ms`
  })

  // Teachers section
  const teacherCards = document.querySelectorAll(".teachers-section .teacher-card")
  teacherCards.forEach((card, index) => {
    card.style.animationDelay = `${index * 200}ms`
  })

  // Benefits section
  const benefitItems = document.querySelectorAll(".benefits-section .benefit-item")
  benefitItems.forEach((item, index) => {
    item.style.animationDelay = `${index * 200}ms`
  })

  // Testimonials section
  const testimonialCards = document.querySelectorAll(".testimonials-section .testimonial-card")
  testimonialCards.forEach((card, index) => {
    card.style.animationDelay = `${index * 200}ms`
  })
})

// Add parallax effect to hero section
window.addEventListener("scroll", () => {
  const scrolled = window.pageYOffset
  const heroSection = document.querySelector(".hero-section")
  const heroContent = document.querySelector(".hero-content")

  if (heroSection && heroContent) {
    const rate = scrolled * -0.5
    heroContent.style.transform = `translateY(${rate}px)`
  }
})

// Add loading animation
window.addEventListener("load", () => {
  document.body.classList.add("loaded")
})

// Statistics counter animation
function animateCounter(element, target, duration = 2000) {
  let start = 0
  const increment = target / (duration / 16)

  function updateCounter() {
    start += increment
    if (start < target) {
      element.textContent = Math.floor(start).toLocaleString()
      requestAnimationFrame(updateCounter)
    } else {
      element.textContent = target.toLocaleString()
    }
  }

  updateCounter()
}

// Animate statistics when they come into view
const statsObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const statNumbers = entry.target.querySelectorAll(".stat-number")
        statNumbers.forEach((stat) => {
          const text = stat.textContent
          const number = Number.parseInt(text.replace(/[^\d]/g, ""))
          const suffix = text.replace(/[\d,]/g, "")

          animateCounter(stat, number)

          // Add suffix back after animation
          setTimeout(() => {
            stat.textContent = number.toLocaleString() + suffix
          }, 2000)
        })
        statsObserver.unobserve(entry.target)
      }
    })
  },
  { threshold: 0.5 },
)

// Observe stats section
const statsSection = document.querySelector(".stats-section")
if (statsSection) {
  statsObserver.observe(statsSection)
}

// Mobile menu toggle (for future enhancement)
function toggleMobileMenu() {
  const mobileMenu = document.querySelector(".mobile-menu")
  if (mobileMenu) {
    mobileMenu.classList.toggle("active")
  }
}

// Form validation (for future contact forms)
function validateForm(form) {
  const inputs = form.querySelectorAll("input[required], textarea[required]")
  let isValid = true

  inputs.forEach((input) => {
    if (!input.value.trim()) {
      input.classList.add("error")
      isValid = false
    } else {
      input.classList.remove("error")
    }
  })

  return isValid
}

// Add hover effects for cards
document.addEventListener("DOMContentLoaded", () => {
  const cards = document.querySelectorAll(".feature-card, .course-card, .teacher-card, .testimonial-card")

  cards.forEach((card) => {
    card.addEventListener("mouseenter", () => {
      card.style.transform = "translateY(-8px)"
    })

    card.addEventListener("mouseleave", () => {
      card.style.transform = "translateY(0)"
    })
  })
})

// Lazy loading for images
if ("IntersectionObserver" in window) {
  const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const img = entry.target
        img.src = img.dataset.src
        img.classList.remove("lazy")
        imageObserver.unobserve(img)
      }
    })
  })

  const lazyImages = document.querySelectorAll("img[data-src]")
  lazyImages.forEach((img) => imageObserver.observe(img))
}

// Add smooth reveal animation for sections
const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = "1"
        entry.target.style.transform = "translateY(0)"
      }
    })
  },
  { threshold: 0.1 },
)

// Performance optimization: Throttle scroll events
function throttle(func, limit) {
  let inThrottle
  return function () {
    const args = arguments
    
    if (!inThrottle) {
      func.apply(this, args)
      inThrottle = true
      setTimeout(() => (inThrottle = false), limit)
    }
  }
}

// Optimized scroll handler
const handleScroll = throttle(() => {
  const scrolled = window.pageYOffset
  const heroSection = document.querySelector(".hero-section")
  const heroContent = document.querySelector(".hero-content")

  if (heroSection && heroContent && scrolled < window.innerHeight) {
    const rate = scrolled * -0.3
    heroContent.style.transform = `translateY(${rate}px)`
  }
}, 16)

window.addEventListener("scroll", handleScroll)

// Add loading states for buttons
document.querySelectorAll(".btn").forEach((button) => {
  button.addEventListener("click", function (e) {
    if (this.classList.contains("btn-primary")) {
      const originalText = this.innerHTML
      this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...'
      this.disabled = true

      // Simulate loading (remove this in production)
      setTimeout(() => {
        this.innerHTML = originalText
        this.disabled = false
      }, 2000)
    }
  })
})

// Console welcome message
console.log("%c🎓 Chào mừng đến với EduTHPT!", "color: #3b82f6; font-size: 20px; font-weight: bold;")
console.log("%cNền tảng học trực tuyến hàng đầu cho học sinh THPT", "color: #6b7280; font-size: 14px;")
