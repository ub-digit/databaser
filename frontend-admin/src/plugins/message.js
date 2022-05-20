import { useToast } from 'vue-toastification'

export const useMessage = () => {
  return {
    set(type, message) {
      const toast = useToast()
      toast[type](message)
    },
    setList(type, message, items) {
      this.set(type, message + items.map(item => `• ${item}` ).join("\n"))
    }
  }
}
