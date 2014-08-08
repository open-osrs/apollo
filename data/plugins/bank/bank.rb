require 'java'

java_import 'org.apollo.game.action.DistancedAction'
java_import 'org.apollo.game.model.inter.bank.BankUtils'

BANK_BOOTH_ID = 2213
BANK_BOOTH_SIZE = 1

# The npcs with a 'bank' menu action.
BANKER_NPCS = [ 166, 494, 495, 496, 497, 498, 499, 1036, 1360, 1702, 2163, 2164, 2354, 2355, 2568, 2569, 2570 ]

# A distanced action to open a new bank.
class BankAction < DistancedAction
  attr_reader :position

  def initialize(mob, position)
    super(0, true, mob, position, BANK_BOOTH_SIZE)
    @position = position
  end

  def executeAction
    mob.turn_to(@position)
    BankUtils.open_bank(mob)
    stop
  end

  def equals(other)
    return (get_class == other.get_class and @position == other.position)
  end
end

# Intercepts the object action event
on :event, :second_object_action do |ctx, player, event|
  if event.id == BANK_BOOTH_ID
    player.start_action(BankAction.new(player, event.position))
    ctx.break_handler_chain
  end
end

on :event, :second_npc_action do |ctx, player, event|
  npc = World.world.npc_repository.get(event.index)
  if BANKER_NPCS.include?(npc.id)
    player.start_action(BankAction.new(player, npc.position))
    ctx.break_handler_chain
  end
end