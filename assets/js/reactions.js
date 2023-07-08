import { createPicker } from "./node_modules/picmo";

// move the picker from item to item on click of the emojis
// // The picker must have a root element to insert itself into
// const rootElement = document.querySelector('#reaction');
// // Create the picker
// const picker = createPicker({ rootElement });
// // The picker emits an event when an emoji is selected. Do with it as you will!
// picker.addEventListener('emoji:select', event => {
//   console.log('Emoji selected:', event.emoji);
// });
let Reactions = {
    init(socket) {
        let channel = socket.channel('cooler:lobby', {})
        channel.join()
        this.listenForReactions(channel)
        this.listenForItemModeration(channel)
    },

    listenForReactions(channel) {
        const rootElement = document.querySelector('#emoji-trigger');
        const picker = createPicker({ rootElement });

        picker.addEventListener('emoji:select', event => {
            console.log(event)
            // handle the selected emoji here
            let item_id = document.getElementById('item_id').value
            let address = document.getElementById('address').value
            channel.push('react', {
                'item_id': item_id,
                'address': address,
                'emoji': event.emoji,
                'description': event.label
            })
        })
        // trigger.addEventListener('click', () => picker.togglePicker(trigger))

        // channel.on('react', payload => {
        //     let reaction = document.querySelector('#reactions')
        //     let msgBlock = document.createElement('p')

        //     msgBlock.insertAdjacentHTML('beforeend', `${payload.emoji}`)
        //     reaction.appendChild(msgBlock)
        // })
    }
}

export default Reactions