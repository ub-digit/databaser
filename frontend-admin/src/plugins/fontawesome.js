import { library } from "@fortawesome/fontawesome-svg-core"
import {faSearch, faArrowLeft, faArrowRight, faTimes, faChevronDown, faChevronUp, faPlus, faMinus, faLock, faLockOpen} from "@fortawesome/free-solid-svg-icons"
import {faSquare, faCheckSquare, faEdit} from "@fortawesome/free-regular-svg-icons"
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome"

library.add(faSearch, faArrowLeft, faArrowRight, faChevronDown, faChevronUp, faTimes, faPlus, faMinus, faSquare, faCheckSquare, faLock, faLockOpen, faEdit);

function useFontawesome() {
  return {
    FontAwesomeIcon
  }
}

export { useFontawesome }